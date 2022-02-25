package kyu.back.repository;

import kyu.back.domain.Factor;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface FactorRepository extends JpaRepository<Factor, Long> {

    Optional<Factor> findFirstByName(String name);

    @Override
    @EntityGraph(attributePaths = {"controlList", "controlList.manage"})
    Optional<Factor> findById(Long aLong);
}
