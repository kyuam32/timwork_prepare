package kyu.back.domain;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import kyu.back.BaseEntity;
import kyu.back.api.dto.FactorDto;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Factor extends BaseEntity {
    @Id
    @GeneratedValue
    @Column(name = "factor_id")
    private Long id;

    @JsonBackReference
    @OneToMany(mappedBy = "factor")
    private List<Evaluate> evaluates = new ArrayList<>();

    @JsonManagedReference
    @OneToMany(mappedBy = "factor",cascade = CascadeType.ALL)
    private List<Control> controlList = new ArrayList<>();

    @JsonManagedReference
    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "category_id")
    private Category category;

    private String name;

    private String stdCode;

    private String law;

    public void addControl(Control control) {
        this.controlList.add(control);
        control.setFactor(this);
    }

    public void joinControll(List<Control> controlList) {
        controlList.forEach(this::addControl);
    }

    static public Factor fromDto(FactorDto factorDto) {
        return Factor.builder()
                .factorDto(factorDto)
                .build();
    }

    @Builder
    public Factor(FactorDto factorDto) {
        this.id = factorDto.getId();
//        this.category = factorDto.getCategory();
        this.law = factorDto.getLaw();
        this.name = factorDto.getName();
        this.stdCode = factorDto.getStdCode();
    }
}
