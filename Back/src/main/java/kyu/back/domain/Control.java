package kyu.back.domain;

import kyu.back.domain.Factor.Factor;
import kyu.back.domain.Manage.Manage;
import lombok.Getter;

import javax.persistence.*;

@Entity
@Getter
public class Control {
    @Id
    @GeneratedValue
    @Column(name = "control_id", nullable = false)
    private Long control_id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "factor_id")
    private Factor factor;

    @ManyToOne(fetch = FetchType.LAZY,cascade = CascadeType.ALL)
    @JoinColumn(name = "manage_id")
    private Manage manage;

}
