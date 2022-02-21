package kyu.back.domain.Factor;

import kyu.back.domain.Category;
import kyu.back.domain.Control;
import kyu.back.domain.Evaluate;
import kyu.back.domain.Law;
import lombok.Getter;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "dtype")
public abstract class Factor {
    @Id
    @GeneratedValue
    @Column(name = "factor_id")
    private Long id;

    @OneToMany(mappedBy = "factor")
    private List<Evaluate> evaluates = new ArrayList<>();

    @OneToMany(mappedBy = "factor",cascade = CascadeType.ALL)
    private List<Control> control = new ArrayList<>();

    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "category_id")
    private Category category;

    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "law_id")
    private Law law;


    private String name;


}
