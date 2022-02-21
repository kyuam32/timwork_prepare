package kyu.back.controller;

import kyu.back.domain.Process.Process;
import kyu.back.repository.ProcessRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class ProcessController {

    private final ProcessRepository processRepository;

    @PostMapping("/api/v1/process")
    public Process save(@RequestBody Process process){
    }
}
