package kyu.back.service;

import kyu.back.api.dto.EvaluateDto;
import kyu.back.domain.Evaluate;
import kyu.back.domain.Factor;
import kyu.back.repository.EvaluateRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class EvalutateService {

    private final EvaluateRepository evaluateRepository;
    private final FactorService factorService;

    public Evaluate update(Long id, EvaluateDto evaluateDto) {
        Evaluate evaluate = Optional.ofNullable(id)
                .map(i -> evaluateRepository
                        .findById(i)
                        .orElseGet(() -> Evaluate.fromDto(evaluateDto)))
                .orElseGet(() -> Evaluate.fromDto(evaluateDto));

        Factor factor = factorService.update(evaluateDto.getFactor().getId(), evaluateDto.getFactor());
        evaluate.setFactor(factor);
        return evaluate;
    }

}
