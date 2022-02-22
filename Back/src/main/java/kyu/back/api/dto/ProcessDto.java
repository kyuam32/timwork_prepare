package kyu.back.api.dto;

import lombok.Data;

import javax.validation.constraints.NotEmpty;
import java.util.ArrayList;
import java.util.List;

@Data
public class ProcessDto {

    private Long id;

    @NotEmpty
    private String name;

    private String stdCode;

    private List<TaskDto> taskList = new ArrayList<>();
}
