package kyu.back.domain;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import kyu.back.api.dto.EvaluateDto;
import lombok.*;

import javax.persistence.*;

@Entity
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Evaluate {
    @Id
    @GeneratedValue
    @Column(name = "evaluate_id", nullable = false)
    private Long id;

    @JsonBackReference
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "task_id")
    private Task task;

    @JsonManagedReference
    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "factor_id")
    private Factor factor;

    private int before_frequency;
    private int before_intensity;
    private int after_frequency;
    private int after_intensity;

    static public Evaluate fromDto(EvaluateDto evaluateDto) {
        return Evaluate.builder()
                .evaluateDto(evaluateDto)
                .build();
    }

    @Builder
    public Evaluate(EvaluateDto evaluateDto) {
        this.id = evaluateDto.getId();
        this.before_frequency = evaluateDto.getBeforeFrequency();
        this.before_intensity = evaluateDto.getBeforeIntensity();
        this.after_frequency = evaluateDto.getAfterFrequency();
        this.after_intensity = evaluateDto.getAfterIntensity();
    }
}
