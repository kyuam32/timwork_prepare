package kyu.back.domain.temp;

import lombok.Getter;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Getter
public class Material {
    @Id
    @GeneratedValue
    @Column(name = "material_id", nullable = false)
    private Long material_id;

    private String name;
}
