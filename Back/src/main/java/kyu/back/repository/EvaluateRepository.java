package kyu.back.repository;

import kyu.back.domain.Evaluate;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EvaluateRepository extends JpaRepository<Evaluate, Long> {

}