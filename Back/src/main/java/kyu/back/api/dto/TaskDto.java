package kyu.back.api.dto;

import kyu.back.domain.Task;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotEmpty;
import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TaskDto {

    private Long id;
    @NotEmpty
    private String name;
    @NotEmpty
    private String description;
    private List<EvaluateDto> evaluateList;
    private String stdCode;

    static public TaskDto toDto(Task task) {
        return TaskDto.builder()
                .id(task.getId())
                .name(task.getName())
                .description(task.getDescription())
                .stdCode(task.getStdCode())
                .build();
    }
}
