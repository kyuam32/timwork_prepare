package kyu.back.repository;

import kyu.back.domain.Process;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ProcessRepository extends JpaRepository<Process, Long> {

    Optional<Process> findFirstByName(String name);

    @Override
    @EntityGraph(attributePaths = {"taskList"})
    Optional<Process> findById(Long Long);
}
