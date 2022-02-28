package kyu.back.service;

import kyu.back.api.dto.EvaluateDto;
import kyu.back.api.dto.FactorDto;
import kyu.back.api.dto.TaskDto;
import kyu.back.domain.Evaluate;
import kyu.back.domain.Task;
import kyu.back.repository.TaskRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;


@Service
@RequiredArgsConstructor
@Transactional
public class TaskService {

    private final TaskRepository taskRepository;
    private final EvalutateService evalutateService;

    public Task update(Long id, TaskDto taskDto) {
        Task task = Optional.ofNullable(id)
                .map(i -> taskRepository.findById(id).get())
                .or(() -> taskRepository.findFirstByName(taskDto.getName()))
                .orElseGet(() -> Task.fromDto(taskDto));

        List<Evaluate> evaluateList = taskDto
                .getEvaluateList()
                .stream()
                .map(evalDto -> evalutateService.update(evalDto.getId(), evalDto))
                .collect(Collectors.toList());

        task.jointEvauate(evaluateList);

        return task;
    }

    public TaskDto findById(Long id) {

        return taskRepository.findById(id)
                .map(task -> TaskDto.builder()
                        .id(task.getId())
                        .name(task.getName())
                        .stdCode(task.getStdCode())
                        .description(task.getDescription())
                        .evaluateList(task.getEvaluateList().stream().map(eval -> EvaluateDto.builder()
                                .id(eval.getId())
                                .beforeIntensity(9)
                                .beforeFrequency(9)
                                .afterIntensity(9)
                                .afterFrequency(9)
                                .factor(FactorDto.builder()
                                        .id(eval.getFactor().getId())
                                        .name(eval.getFactor().getName())
                                        .law(eval.getFactor().getLaw())
                                        .stdCode(eval.getFactor().getStdCode())
                                        .build())
                                .build()).collect(Collectors.toList()))
                        .build())
                .orElse(null);
    }
}
