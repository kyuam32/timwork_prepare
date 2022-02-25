package kyu.back.service;

import kyu.back.api.dto.ProcessDto;
import kyu.back.api.dto.TaskDto;
import kyu.back.domain.Process;
import kyu.back.domain.Task;
import kyu.back.repository.ProcessRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class ProcessService {

    private final ProcessRepository processRepository;
    private final TaskService taskService;

    public Process update(Long id, ProcessDto processDto) {

        Process process = Optional.ofNullable(id)
                .map(i -> processRepository.findById(i).get())
                .or(() -> processRepository.findFirstByName(processDto.getName()))
                .orElseGet(() -> Process.fromDto(processDto));

        List<Task> taskList = processDto
                .getTaskList()
                .stream()
                .map(taskdto -> taskService.update(taskdto.getId(), taskdto))
                .collect(Collectors.toList());

        process.jointTask(taskList);

        return processRepository.save(process);
    }


    public List<ProcessDto> listProcess() {
        return processRepository.findAll()
                .stream()
                .map((ProcessDto::toDto))
                .collect(Collectors.toList());
    }

    public ProcessDto findById(Long id) {
        return processRepository.findById(id)
                .map((process -> ProcessDto.builder()
                        .id(process.getId())
                        .name(process.getName())
                        .stdCode(process.getStdCode())
                        .taskList(process.getTaskList()
                                .stream()
                                .map(TaskDto::toDto)
                                .collect(Collectors.toList()))
                        .build()))
                .orElse(null);
    }

}
