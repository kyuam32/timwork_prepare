package kyu.back.domain;

import lombok.Getter;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
public class Category {
    @Id
    @GeneratedValue
    @Column(name = "category_id", nullable = false)
    private Long category_id;

    private String name;

    @OneToMany(mappedBy = "category")
    private List<Factor> factors = new ArrayList<>();

    @OneToMany(mappedBy = "category",cascade = CascadeType.ALL)
    private List<CategoryDetail> categoryDetail = new ArrayList<>();
}
