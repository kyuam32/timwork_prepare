package kyu.back.repository;

import kyu.back.domain.Factor.Factor;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FactorRepository extends JpaRepository<Factor, Long> {
}
