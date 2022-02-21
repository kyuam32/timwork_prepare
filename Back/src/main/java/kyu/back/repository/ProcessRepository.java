package kyu.back.repository;

import kyu.back.domain.Process.Process;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProcessRepository extends JpaRepository<Process, Long> {

}
