package kyu.back.service;

import kyu.back.api.dto.ProcessDto;
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
                .map(i -> processRepository
                        .findById(i)
                        .or(() -> processRepository.findByName(processDto.getName()))
                        .orElseGet(() -> Process.fromDto(processDto)))
                .orElseGet(() -> Process.fromDto(processDto));

//        Process process = Optional.ofNullable(id)
//                .map(i -> processRepository
//                        .findById(i)
//                        .orElseGet(() -> Process.fromDto(processDto)))
//                .orElseGet(() -> Process.fromDto(processDto));

        List<Task> taskList = processDto
                .getTaskList()
                .stream()
                .map(taskdto -> taskService.update(taskdto.getId(), taskdto))
                .collect(Collectors.toList());

        process.jointTask(taskList);

        return processRepository.save(process);
    }


    public List<Process> listProcess() {
        return processRepository.findAll();
    }

}
