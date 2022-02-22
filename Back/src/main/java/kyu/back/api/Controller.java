package kyu.back.api;

import kyu.back.api.dto.ProcessDto;
import kyu.back.domain.Process;
import kyu.back.service.ProcessService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequiredArgsConstructor
public class Controller {

    private final ProcessService processService;


    @PostMapping("/api/v1/process")
    public Process save(@RequestBody @Valid ProcessDto processDto) {
        return processService.update(processDto.getId(), processDto);
    }

    @GetMapping("/api/v1/process")
    public List<Process> list(){
        return processService.listProcess();
    }
}
