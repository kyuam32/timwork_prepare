# -*- coding: utf-8 -*-

import os
import re

import requests
import time
import json
import pandas as pd
from bs4 import BeautifulSoup


url = "https://kras.kosha.or.kr/riskcheck/"
headers = {'Cookie': 'KRASJSESSIONID=LmBoBLZlO1LDL8po97M9yXeso6rFT28HFXjPROWFCwpGwKsDpIXoUihC1NzhiePx.KRAS-WAS1_servlet_engine1; WMONID=PzOWiVvBvBC'}


def jsonSort():
    with open("./data/indexlist.json", "r") as read_file:
        list = json.load(read_file)

    data = []

    for row in list["body"]:
        temp = [
            row["bizCode1"],
            row["bizCode1Nm"],
            row["bizCode2"],
            row["bizCode2Nm"],
            row["bizCode3"],
            row["bizCode3Nm"],
            row["stdProcessCd"],
            row["processName"],
        ]

        data.append(temp)
    frame = pd.DataFrame(data, columns=["bizCode1",
                                        "bizCode1Nm",
                                        "bizCode2",
                                        "bizCode2Nm",
                                        "bizCode3",
                                        "bizCode3Nm",
                                        "stdProcessCd",
                                        "processName", ])

    frame.to_csv("./result/processlist.csv", index=False)

def req_add_process(stdProcessCd):
    endpoint = url + "step1/api_addnewprocess"
    payload = {"stdProcessCd" : stdProcessCd}

    response = requests.request("POST", endpoint, headers=headers, data=payload).json()

    return response["body"]

def req_del_process(process):
    endpoint = url + "step1/api_deleteprocess"
    payload ={
        "riskProcessSeq": process["riskProcessSeq"],
        "userId": process["userId"],
        "stdProcessCd": process["stdProcessCd"],
        "insertDate": process["insertDate"],
        "updateDate": process["updateDate"]
    }

    response = requests.request("POST", endpoint, headers=headers, json=payload).json()

    return response


def req_get_tasklist(riskProcessSeq):
    endpoint = url + f"api_getrisktasklist/{riskProcessSeq}"
    response = requests.request("POST", endpoint, headers=headers, data={}).json()

    for rows in response["body"]:
        rows["riskProcessSeq"] = riskProcessSeq
        rows["taskMaterials"] = ""
        rows["userId"] = "null"
        rows["riskMatrixType"] = "null"
        rows["hasChildFactors"] = "null"

    return response["body"]

def req_save_tasklist(riskProcessSeq, tasks):
    endpoint = url + "step1/api_savetasklist"
    payload = {
        "riskProcessSeq": riskProcessSeq,
        "riskTaskListToAdd": tasks,
        "riskTaskListToUpdate": [],
        "riskTaskListToDelete": [],
    }
    response = requests.request("POST", endpoint, headers=headers, json=payload).json()

def req_get_tasklist_seq():
    endpoint = url + "api_getrisktasklistwithhasfactors"
    response = requests.request("POST", endpoint, headers=headers).json()
    return response["body"]

def req_get_factors(tasks_detail):
    factors = []
    for rows in tasks_detail:
        factor = {
            "riskProcessSeq" : rows['riskProcessSeq'],
            "riskTaskSeq" : rows['riskTaskSeq'],
            "taskName" : rows['taskName'],
            "stdTaskCd" : rows['stdTaskCd'],
            "factor": None,
        }
        endpoint = url + f"api_getriskfactorlist/{rows['riskTaskSeq']}"
        # get factor list
        response = requests.request("POST", endpoint, headers=headers).json()
        # save factor list
        req_save_factorlist(factor["riskTaskSeq"], response["body"])
        # update riskFactorSeq
        response = requests.request("POST", endpoint, headers=headers).json()
        factor["factor"] = (response["body"])
        factors.append(factor)

    return factors

def req_save_factorlist(riskTaskSeq, tasks):
    endpoint = url + "step2/api_savefactorlist"
    payload = {
        "riskTaskSeq": riskTaskSeq,
        "riskFactorListToAdd": tasks,
        "riskTaskListToUpdate": [],
        "riskTaskListToDelete": [],
    }
    response = requests.request("POST", endpoint, headers=headers, json=payload).json()

def req_get_manage_list(factors):
    manages = []
    i = 0
    for tasks in factors:
        for rows in tasks['factor']:
            manage = {
                'stdTaskCd': rows['stdTaskCd'],
                'riskFactorSeq': rows['riskFactorSeq'],
                'riskFactor': rows['riskFactor'],
                'manage': bs_scrap(rows['riskFactorSeq'])
            }
            manages.append(manage)

    return manages

def bs_scrap(riskFactorSeq):
    endpoint = url + f"step3/riskmeasurepopup/{riskFactorSeq}"
    response = requests.get(endpoint, headers=headers)
    soup = BeautifulSoup(response.text, "html.parser")
    # print(str(soup.findAll('script', type="text/javascript")))
    res_list = re.findall(r'var\s+riskMeasureMngList\s*=\s*(.*?);', str(soup.findAll('script', type="text/javascript")), flags=re.DOTALL)
    res_string = ''.join(map(str, res_list))
    res_json = json.loads(res_string)
    return res_json

    # res = json.dumps(json_string, ensure_ascii=False)
    # print(res)

def to_csv(df, path):
    if not os.path.exists(path):
        df.to_csv(path, index=False, mode='w', encoding='utf-8-sig')
    else:
        df.to_csv(path, index=False, mode='a', encoding='utf-8-sig', header=False)

def to_csv_task(tasks):
    data = []
    for row in tasks:
        task = [
            row['processName'],
            row['stdProcessCd'],
            row['taskOrder'],
            row['taskName'],
            row['taskDesc'],
            row['taskMachines'],
            row['taskMaterials'],
            row['stdTaskCd'],
        ]
        data.append(task)
    result = pd.DataFrame(data, columns=['processName','stdTaskCd','taskOrder','taskName','taskDesc','taskMachines','taskMaterials','stdProcessCd'])
    to_csv(result, "./data/task_list.csv")

def to_csv_factor(factors):
    data = []
    for row in factors:
        taskName = row['taskName']
        stdTaskCd = row['stdTaskCd']
        for sub_row in row['factor']:
            factor = [
                taskName,
                stdTaskCd,
                sub_row["riskCate1Cd"],
                sub_row["riskCate1Name"],
                sub_row["riskCate2Cd"],
                sub_row["riskCate2Name"],
                sub_row["riskFactor"],
                sub_row["riskRelatedLaw"],
                sub_row["stdRiskFactorSeq"],
            ]
            data.append(factor)
    result = pd.DataFrame(data, columns=['taskName','stdTaskCd',"riskCate1Cd","riskCate1Name","riskCate2Cd","riskCate2Name","riskFactor","riskRelatedLaw", "stdRiskFactorSeq"])
    to_csv(result, "./data/factor_list.csv")

def to_csv_manage(manages):
    data = []
    for row in manages:
        stdTaskCd = row['stdTaskCd']
        riskFactor = row["riskFactor"]
        for sub_row in row['manage']:
            manage = [
                stdTaskCd,
                sub_row["stdRiskFactorSeq"],
                sub_row["stdRiskMeasureSeq"],
                riskFactor,
                sub_row["stdSafetyMeasure"],
            ]
            data.append(manage)
    result = pd.DataFrame(data, columns=['stdTaskCd', "stdRiskFactorSeq", "stdRiskMeasureSeq", "riskFactor", "stdSafetyMeasure",])
    to_csv(result, "./data/manage_list.csv")

# 1. process 추가 - step1/api_addnewprocess
# 2. proc list 받기, process seq 확인 - api_getriskprocesslist
# 3. proc seq 로 task list 받기, 여기선 task seq 확인 안됨 - api_getrisktasklist/{proc seq}
# 4. 현재 task list 저장 - step1/api_savetasklist
# 5. task seq 할당된 task list 받기 - api_getrisktasklistwithhasfactors
# 6. task seq 로 factor list 받기, - api_getriskfactorlist/{task seq}
# 7. 현재 factor list 저장

# 7. factor seq 로 manage 방법 받기, GET - step3/riskmeasurepopup/{factor seq}
# 8. 추출

# def req_get_MeasureMng_List(Factors)


if __name__ == '__main__':

    p_list = pd.read_csv("./result/process_list.csv")
    data = []

    i = 0

    for _, rows in p_list.iterrows():

        print(f"curr {i}nd data")

        pid = rows["stdProcessCd"]
        process = req_add_process(pid)

        tasks = req_get_tasklist(process['riskProcessSeq'])
        req_save_tasklist(process['riskProcessSeq'], tasks)
        to_csv_task(tasks)
        tasks_seq = req_get_tasklist_seq()


        factors = req_get_factors(tasks_seq)
        to_csv_factor(factors)

        manages = req_get_manage_list(factors)
        to_csv_manage(manages)

        req_del_process(process)

        i+= 1
        # if (i >= 1):
        #     break
        time.sleep(5)