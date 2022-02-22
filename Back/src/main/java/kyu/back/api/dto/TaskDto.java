package kyu.back.api.dto;

import lombok.Data;

import javax.validation.constraints.NotEmpty;
import java.util.List;

@Data
public class TaskDto {

    private Long id;
    @NotEmpty
    private String name;
    @NotEmpty
    private String description;
    private List<EvaluateDto> evaluateList;
    private String stdCode;
}
