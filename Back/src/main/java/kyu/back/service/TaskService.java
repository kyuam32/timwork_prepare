package kyu.back.service;

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
        Task task = Optional.ofNullable(id).map(i -> taskRepository
                        .findById(id)
                        .orElseGet(() -> Task.fromDto(taskDto)))
                .orElseGet(() -> Task.fromDto(taskDto));

        List<Evaluate> evaluateList = taskDto
                .getEvaluateList()
                .stream()
                .map(evalDto -> evalutateService.update(evalDto.getId(), evalDto))
                .collect(Collectors.toList());

        task.jointEvauate(evaluateList);

        return taskRepository.save(task);
    }

}
