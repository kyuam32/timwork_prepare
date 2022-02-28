package kyu.back.api;

import kyu.back.api.dto.FactorDto;
import kyu.back.api.dto.ProcessDto;
import kyu.back.api.dto.TaskDto;
import kyu.back.api.response.Response;
import kyu.back.domain.Process;
import kyu.back.repository.TaskRepository;
import kyu.back.service.FactorService;
import kyu.back.service.ProcessService;
import kyu.back.service.TaskService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
public class ApiController {

    private final ProcessService processService;
    private final TaskService taskService;
    private final FactorService factorService;
    private final TaskRepository taskRepository;

    @PostMapping("/api/v1/process")
    public Response<Process> save(@RequestBody @Valid ProcessDto processDto) {
        return Response.<Process>builder()
                .message("Success")
                .data(processService.update(processDto.getId(), processDto))
                .build();
    }

    @GetMapping("/api/v1/process")
    public Response<List<ProcessDto>> listProcess(){
        return Response.<List<ProcessDto>>builder()
                .message("Success")
                .data(processService.listProcess())
                .build();
    }

    @GetMapping("/api/v1/process/{id}")
    public Response<ProcessDto> processById(@PathVariable("id") Long id) {

        return Optional.ofNullable(processService.findById(id))
                .map(res -> Response.<ProcessDto>builder()
                        .message("Success")
                        .data(res)
                        .build())
                .orElse(Response.<ProcessDto>builder()
                        .error("error")
                        .message("결과를 찾을 수 없음")
                        .build());
    }


    @GetMapping("/api/v1/task/{id}")
    public Response<TaskDto> taskById(@PathVariable("id") Long id) {
        return Optional.ofNullable(taskService.findById(id))
                .map(res -> Response.<TaskDto>builder()
                        .message("Success")
                        .data(res)
                        .build())
                .orElse(Response.<TaskDto>builder()
                        .error("error")
                        .message("결과를 찾을 수 없음")
                        .build());
    }

    @GetMapping("/api/v1/factor/{id}")
    public Response<FactorDto> factorListById(@PathVariable("id") Long id) {
        return Optional.ofNullable(factorService.findById(id))
                .map(res -> Response.<FactorDto>builder()
                        .message("Success")
                        .data(res)
                        .build())
                .orElse(Response.<FactorDto>builder()
                        .error("error")
                        .message("결과를 찾을 수 없음")
                        .build());
    }
}
