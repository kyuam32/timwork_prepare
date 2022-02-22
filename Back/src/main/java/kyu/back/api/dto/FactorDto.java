package kyu.back.api.dto;

import lombok.Data;

import javax.validation.constraints.NotEmpty;
import java.util.List;

@Data
public class FactorDto {
    private Long id;
//    private Category category;
    private String law;
    @NotEmpty
    private String name;
    private String stdCode;
    @NotEmpty
    private List<ControlDto> controlList;
}
