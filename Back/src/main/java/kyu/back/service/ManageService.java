package kyu.back.service;


import kyu.back.api.dto.ManageDto;
import kyu.back.domain.Manage;
import kyu.back.repository.ManageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@Transactional
@RequiredArgsConstructor
public class ManageService {

    private final ManageRepository manageRepository;

    public Manage update(Long id, ManageDto manageDto) {
        Manage manage = Optional.ofNullable(id)
                .map(i -> manageRepository.findById(i).get())
                .or(() -> manageRepository.findFirstByName(manageDto.getName()))
                .orElseGet(() -> Manage.fromDto(manageDto));

        return manage;
    }

}
