package kyu.back.domain;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import kyu.back.api.dto.ControlDto;
import lombok.*;

import javax.persistence.*;

@Entity
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Control {
    @Id
    @GeneratedValue
    @Column(name = "control_id", nullable = false)
    private Long id;

    @JsonBackReference
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "factor_id")
    private Factor factor;

    @JsonManagedReference
    @ManyToOne(fetch = FetchType.LAZY,cascade = CascadeType.ALL)
    @JoinColumn(name = "manage_id")
    private Manage manage;

    static public Control fromDto(ControlDto controlDto) {
        return Control.builder()
                .controlDto(controlDto)
                .build();
    }

    @Builder
    public Control(ControlDto controlDto) {
        this.id = controlDto.getId();
    }
}
