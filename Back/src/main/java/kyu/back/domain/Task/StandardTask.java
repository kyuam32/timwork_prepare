package kyu.back.domain.Task;

import lombok.Getter;

import javax.persistence.DiscriminatorColumn;
import javax.persistence.Entity;

@Entity
@Getter
@DiscriminatorColumn(name = "standard")
public class StandardTask extends Task {
    private String stdCode;
}
