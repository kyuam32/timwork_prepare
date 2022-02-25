package kyu.back.api.dto;

import kyu.back.domain.Process;
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
public class ProcessDto {

    private Long id;

    @NotEmpty
    private String name;

    private String stdCode;

    private List<TaskDto> taskList;

    static public ProcessDto toDto(Process process) {
        return ProcessDto.builder()
                .id(process.getId())
                .name(process.getName())
                .stdCode(process.getStdCode())
                .build();
    }

}
