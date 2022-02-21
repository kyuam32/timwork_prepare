package kyu.back.domain;

import kyu.back.domain.Factor.Factor;
import kyu.back.domain.Task.Task;
import lombok.Getter;

import javax.persistence.*;

@Entity
@Getter
public class Evaluate {
    @Id
    @GeneratedValue
    @Column(name = "evaluate_id", nullable = false)
    private Long evaluate_id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "task_id")
    private Task task;

    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "factor_id")
    private Factor factor;

    @Embedded
    @AttributeOverride(name = "frequency", column = @Column(name = "before_frequency"))
    @AttributeOverride(name = "intensity", column = @Column(name = "before_intensity"))
    private Score scoreBefore;


    @Embedded
    @AttributeOverride(name = "frequency", column = @Column(name = "after_frequency"))
    @AttributeOverride(name = "intensity", column = @Column(name = "after_intensity"))
    private Score scoreAfter;
}
