package kyu.back.domain;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import kyu.back.BaseEntity;
import kyu.back.api.dto.TaskDto;
import lombok.*;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Task extends BaseEntity {
    @Id
    @GeneratedValue
    @Column(name = "task_id")
    private Long id;

    @JsonBackReference
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "process_id")
    private Process process;

    private String name;
    private String description;
    private String stdCode;

    @JsonManagedReference
    @OneToMany(mappedBy = "task", cascade = CascadeType.ALL)
    private List<Evaluate> evaluateList = new ArrayList<>();


    public void addEvaluate(Evaluate evaluate) {
        this.evaluateList.add(evaluate);
        evaluate.setTask(this);
    }

    public void jointEvauate(List<Evaluate> evaluateList) {
        evaluateList.forEach(this::addEvaluate);
    }

//    private List<Machine> machine;
//    private List<Material> material;

    static public Task fromDto(TaskDto taskDto) {
        return Task.builder()
                .taskDto(taskDto)
                .build();
    }

    @Builder
    public Task(TaskDto taskDto) {
        this.id = taskDto.getId();
        this.name = taskDto.getName();
        this.description = taskDto.getDescription();
        this.stdCode = taskDto.getStdCode();
    }
}
