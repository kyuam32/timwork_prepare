package kyu.back.domain.Manage;

import kyu.back.domain.Control;
import lombok.Getter;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "dtype")
public abstract class Manage {
    @Id
    @GeneratedValue
    @Column(name = "manage_id")
    private Long id;

    @OneToMany(mappedBy = "manage")
    private List<Control> danger = new ArrayList<>();

    private String name;
}
