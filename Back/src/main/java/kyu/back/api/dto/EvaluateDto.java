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
    private int beforeFrequency;
    private int beforeIntensity;
    private int afterFrequency;
    private int afterIntensity;

    static public EvaluateDto toDto(Evaluate evaluate) {
        return EvaluateDto.builder()
                .id(evaluate.getId())
                .beforeFrequency(9)
                .afterFrequency(9)
                .beforeIntensity(9)
                .afterIntensity(9)
                .build();
    }

}
