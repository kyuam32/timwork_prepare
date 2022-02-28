package kyu.back.repository;

import kyu.back.domain.Manage;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ManageRepository extends JpaRepository<Manage, Long> {

    Optional<Manage> findFirstByName(String name);
}