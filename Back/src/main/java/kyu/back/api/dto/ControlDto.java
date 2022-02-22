package kyu.back.api.dto;

import lombok.Data;

import javax.validation.constraints.NotEmpty;

@Data
public class ControlDto {
    private Long id;
    @NotEmpty
    private ManageDto manage;

}
