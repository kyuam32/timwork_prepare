package kyu.back.domain.Task;

import kyu.back.domain.Evaluate;
import kyu.back.domain.Process.Process;
import lombok.Getter;

import javax.persistence.*;
import java.util.List;

@Entity
@Getter
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "dtype")
public abstract class Task {
    @Id
    @GeneratedValue
    @Column(name = "task_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "process_id")
    private Process process;

    @OneToMany(mappedBy = "task", cascade = CascadeType.ALL)
    private List<Evaluate> evaluate;

    private String name;
    private String description;

//    private List<Machine> machine;
//    private List<Material> material;
}
