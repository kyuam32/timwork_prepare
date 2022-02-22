package kyu.back.api.dto;

import lombok.Data;

@Data
public class EvaluateDto {
    private Long id;
    private FactorDto factor;
    private int before_frequency;
    private int before_intensity;
    private int after_frequency;
    private int after_intensity;
}
