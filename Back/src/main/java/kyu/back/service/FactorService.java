package kyu.back.service;

import kyu.back.api.dto.ControlDto;
import kyu.back.api.dto.FactorDto;
import kyu.back.api.dto.ManageDto;
import kyu.back.domain.Control;
import kyu.back.domain.Factor;
import kyu.back.repository.FactorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor
public class FactorService {

    private final FactorRepository factorRepository;
    private final ControlService controlService;

    public Factor update(Long id, FactorDto factorDto) {
        Factor factor = Optional.ofNullable(id)
                .map(i -> factorRepository.findById(i).get())
                .or(() -> factorRepository.findFirstByName(factorDto.getName()))
                .orElseGet(() -> Factor.fromDto(factorDto));

        List<Control> controlList = factorDto
                .getControlList()
                .stream()
                .map(ctrlDto -> controlService.update(ctrlDto.getId(), ctrlDto))
                .collect(Collectors.toList());

        factor.joinControll(controlList);

        return factor;
    }

    public FactorDto findById(Long id) {
        return factorRepository.findById(id)
                .map(factor -> FactorDto.builder()
                        .id(factor.getId())
                        .law(factor.getLaw())
                        .name(factor.getName())
                        .stdCode(factor.getStdCode())
                        .controlList(factor.getControlList().stream()
                                .map(control -> ControlDto.builder()
                                        .id(control.getId())
                                        .manage(ManageDto.builder()
                                                .id(control.getFactor().getId())
                                                .name(control.getFactor().getName())
                                                .build())
                                        .build())
                                .collect(Collectors.toList()))
                        .build())
                .orElse(null);

    }


}
