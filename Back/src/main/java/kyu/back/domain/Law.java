package kyu.back.domain;

import kyu.back.domain.Factor.Factor;
import lombok.Getter;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
public class Law {
    @Id
    @GeneratedValue
    @Column(name = "law_id", nullable = false)
    private Long law_id;

    @OneToMany(mappedBy = "law")
    private List<Factor> factors = new ArrayList<>();

    private String name;
}
