package kyu.back.domain.Process;

import kyu.back.domain.Task.Task;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "dtype")
public abstract class Process {
    @Id
    @GeneratedValue
    @Column(name = "process_id")
    private Long id;

    private String name;

    @OneToMany(mappedBy = "process", cascade = CascadeType.ALL)
    private List<Task> task = new ArrayList<>();
}
