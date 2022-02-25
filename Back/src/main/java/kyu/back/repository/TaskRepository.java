package kyu.back.repository;

import kyu.back.domain.Task;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface TaskRepository extends JpaRepository<Task, Long> {

    Optional<Task> findFirstByName(String name);


    @Override
    @EntityGraph(attributePaths = {"evaluateList", "evaluateList.factor"})
    Optional<Task> findById(Long aLong);

}
