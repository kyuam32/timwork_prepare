package kyu.back.service;

import kyu.back.api.dto.ControlDto;
import kyu.back.domain.Control;
import kyu.back.domain.Manage;
import kyu.back.repository.ControlRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@Transactional
@RequiredArgsConstructor
public class ControlService {

    private final ControlRepository controlRepository;
    private final ManageService manageService;

    public Control update(Long id, ControlDto controlDto) {
        Control control = Optional.ofNullable(id)
                .map(i -> controlRepository
                        .findById(i)
                        .orElseGet(() -> Control.fromDto(controlDto)))
                .orElseGet(() -> Control.fromDto(controlDto));

        Manage manage = manageService.update(controlDto.getManage().getId(), controlDto.getManage());

        control.setManage(manage);

        return control;
    }

}
