package kyu.back.service;

import kyu.back.api.dto.FactorDto;
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
                .map(i -> factorRepository
                        .findById(i)
                        .orElseGet(() -> Factor.fromDto(factorDto)))
                .orElseGet(() -> Factor.fromDto(factorDto));

        List<Control> controlList = factorDto
                .getControlList()
                .stream()
                .map(ctrlDto -> controlService.update(ctrlDto.getId(), ctrlDto))
                .collect(Collectors.toList());

        factor.joinControll(controlList);

        return factorRepository.save(factor);
    }
}
