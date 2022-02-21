package kyu.back.repository;

import kyu.back.domain.Process.Process;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@SpringBootTest
@Transactional
public class ProcessRepositoryTest {

    @Autowired
    ProcessRepository processRepository;

    @Test
    public void 프로세스_목록_가져오기() throws Exception {
      //given
        List<Process> processes = processRepository.findAll();
        //when

      //then

    }
}
