package kyu.back.repository;

import kyu.back.domain.Manage;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ManageRepository extends JpaRepository<Manage, Long> {
}