package kyu.back.api.dto;

import kyu.back.domain.Factor;
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
public class FactorDto {
    private Long id;
//    private Category category;
    private String law;
    @NotEmpty
    private String name;
    private String stdCode;
    @NotEmpty
    private List<ControlDto> controlList;

    static public FactorDto toDto(Factor factor) {
        return FactorDto.builder()
                .id(factor.getId())
                .name(factor.getName())
                .law(factor.getLaw())
                .stdCode(factor.getStdCode())
                .build();
    }
}
