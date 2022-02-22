package kyu.back.domain;

import com.fasterxml.jackson.annotation.JsonBackReference;
import kyu.back.BaseEntity;
import kyu.back.api.dto.ManageDto;
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
public class Manage extends BaseEntity {
    @Id
    @GeneratedValue
    @Column(name = "manage_id")
    private Long id;

    @JsonBackReference
    @OneToMany(mappedBy = "manage")
    private List<Control> controlList = new ArrayList<>();

    private String name;

    static public Manage fromDto(ManageDto manageDto) {
        return Manage.builder()
                .manageDto(manageDto)
                .build();
    }

    @Builder
    public Manage(ManageDto manageDto) {
        this.id = manageDto.getId();
        this.name = manageDto.getName();
    }
}
