package kyu.back.domain;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import kyu.back.BaseEntity;
import kyu.back.api.dto.ProcessDto;
import lombok.*;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Process extends BaseEntity {
    @Id
    @GeneratedValue
    @Column(name = "process_id")
    private Long id;

    private String name;

    private String stdCode;

    @JsonManagedReference
    @OneToMany(mappedBy = "process", cascade = CascadeType.ALL)
    private List<Task> taskList = new ArrayList<>();

    public void addTask(Task task) {
        this.taskList.add(task);
        task.setProcess(this);
    }

    public void jointTask(List<Task> taskList) {
        taskList.forEach(this::addTask);
    }


    static public Process fromDto(ProcessDto processDto) {
        return Process.builder()
                .processDto(processDto)
                .build();
    }

    public Process(Long id, String name, String stdCode, List<Task> taskList) {
        this.id = id;
        this.name = name;
        this.stdCode = stdCode;
        this.taskList = taskList;
    }

    @Builder
    public Process(ProcessDto processDto) {
        this.id = processDto.getId();
        this.name = processDto.getName();
        this.stdCode = processDto.getStdCode();
    }
}
