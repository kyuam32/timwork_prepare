# -*- coding: utf-8 -*-

import os
import requests
import time
import json
import pandas as pd

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
    url = "https://kras.kosha.or.kr/riskcheck/step1/api_addnewprocess"
    payload = {"stdProcessCd" : stdProcessCd}
    headers = {
        'Cookie': 'KRASJSESSIONID=LmBoBLZlO1LDL8po97M9yXeso6rFT28HFXjPROWFCwpGwKsDpIXoUihC1NzhiePx.KRAS-WAS1_servlet_engine1; WMONID=PzOWiVvBvBC'
    }

    response = requests.request("POST", url, headers=headers, data=payload).json()

    return response["body"]

def req_del_process(process):
    url = "https://kras.kosha.or.kr/riskcheck/step1/api_deleteprocess"
    payload ={
        "riskProcessSeq": process["riskProcessSeq"],
        "userId": process["userId"],
        "stdProcessCd": process["stdProcessCd"],
        "insertDate": process["insertDate"],
        "updateDate": process["updateDate"]
    }
    headers = {
        'Cookie': 'KRASJSESSIONID=LmBoBLZlO1LDL8po97M9yXeso6rFT28HFXjPROWFCwpGwKsDpIXoUihC1NzhiePx.KRAS-WAS1_servlet_engine1; WMONID=PzOWiVvBvBC',
    }

    response = requests.request("POST", url, headers=headers, json=payload).json()

    return response


def req_get_tasklist(riskProcessSeq):
    url = f"https://kras.kosha.or.kr/riskcheck/api_getrisktasklist/{riskProcessSeq}"
    headers = {
        'Cookie': 'KRASJSESSIONID=LmBoBLZlO1LDL8po97M9yXeso6rFT28HFXjPROWFCwpGwKsDpIXoUihC1NzhiePx.KRAS-WAS1_servlet_engine1; WMONID=PzOWiVvBvBC'
    }
    response = requests.request("POST", url, headers=headers, data={}).json()

    for rows in response["body"]:
        rows["riskProcessSeq"] = riskProcessSeq
        rows["taskMaterials"] = ""
        rows["userId"] = "null"
        rows["riskMatrixType"] = "null"
        rows["hasChildFactors"] = "null"

    return response["body"]

def req_save_tasklist(riskProcessSeq, tasks):
    url = "https://kras.kosha.or.kr/riskcheck/step1/api_savetasklist"
    headers = {
        'Cookie': 'KRASJSESSIONID=LmBoBLZlO1LDL8po97M9yXeso6rFT28HFXjPROWFCwpGwKsDpIXoUihC1NzhiePx.KRAS-WAS1_servlet_engine1; WMONID=PzOWiVvBvBC'
    }
    payload = {
        "riskProcessSeq": riskProcessSeq,
        "riskTaskListToAdd": tasks,
        "riskTaskListToUpdate": [],
        "riskTaskListToDelete": [],
    }
    response = requests.request("POST", url, headers=headers, json=payload).json()

def req_get_detailed_tasklist():
    url = "https://kras.kosha.or.kr/riskcheck/api_getrisktasklistwithhasfactors"
    headers = {
        'Cookie': 'KRASJSESSIONID=LmBoBLZlO1LDL8po97M9yXeso6rFT28HFXjPROWFCwpGwKsDpIXoUihC1NzhiePx.KRAS-WAS1_servlet_engine1; WMONID=PzOWiVvBvBC'
    }
    response = requests.request("POST", url, headers=headers).json()
    return response["body"]

def req_get_risk_factors(tasks_detail):
    factors = []
    for rows in tasks_detail:
        factor = {
            "riskProcessSeq" : rows['riskProcessSeq'],
            "taskName" : rows['taskName'],
            "stdTaskCd" : rows['stdTaskCd'],
            "factor": None,
        }
        url = f"https://kras.kosha.or.kr/riskcheck/api_getriskfactorlist/{rows['riskTaskSeq']}"
        headers = {
            'Cookie': 'KRASJSESSIONID=LmBoBLZlO1LDL8po97M9yXeso6rFT28HFXjPROWFCwpGwKsDpIXoUihC1NzhiePx.KRAS-WAS1_servlet_engine1; WMONID=PzOWiVvBvBC'
        }
        response = requests.request("POST", url, headers=headers).json()
        factor["factor"] = (response["body"])
        factors.append(factor)

    return factors

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
            row['stdTaskCd'],
        ]
        data.append(task)
    result = pd.DataFrame(data, columns=['processName','stdTaskCd','taskOrder','taskName','taskDesc','taskMachines','stdProcessCd'])
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
            ]
            data.append(factor)
    result = pd.DataFrame(data, columns=['taskName','stdTaskCd',"riskCate1Cd","riskCate1Name","riskCate2Cd","riskCate2Name","riskFactor","riskRelatedLaw"])
    to_csv(result, "./data/factor_list.csv")

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
        tasks_detail = req_get_detailed_tasklist()

        factors = req_get_risk_factors(tasks_detail)
        to_csv_factor(factors)

        req_del_process(process)

        i+= 1

        time.sleep(3)