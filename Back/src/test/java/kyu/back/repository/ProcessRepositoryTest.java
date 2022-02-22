package kyu.back.repository;

import kyu.back.domain.Process;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Optional;

@SpringBootTest
@Transactional
public class ProcessRepositoryTest {

    @Autowired
    ProcessRepository processRepository;

    @Test
    public void 옵셔널테스트() throws Exception {

        Process process = new Process(1L, "or", "123", new ArrayList<>());
        Process process2 = new Process(1L, "orelse", "123", new ArrayList<>());
        Process processNull = null;

        Process processLast = processRepository
                .findById(1L)
                .or(() -> Optional.ofNullable(process))
                .orElse(process2);
        System.out.println("processLast = " + processLast.getName());
        Assertions.assertEquals(process, processLast);

        processLast = processRepository
                .findById(1L)
                .or(() -> Optional.ofNullable(processNull))
                .orElse(process2);
        System.out.println("processLast = " + processLast.getName());
        Assertions.assertEquals(process2, processLast);
    }
}
