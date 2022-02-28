package kyu.back.api.dto;

import kyu.back.domain.Evaluate;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class EvaluateDto {
    private Long id;
    private FactorDto factor;
    private int before_frequency;
    private int before_intensity;
    private int after_frequency;
    private int after_intensity;

    static public EvaluateDto toDto(Evaluate evaluate) {
        return EvaluateDto.builder()
                .id(evaluate.getId())
                .before_frequency(9)
                .after_frequency(9)
                .before_intensity(9)
                .after_intensity(9)
                .build();
    }

}
