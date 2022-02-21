package kyu.back.domain.Task;

import lombok.Getter;

import javax.persistence.DiscriminatorColumn;
import javax.persistence.Entity;

@Entity
@Getter
@DiscriminatorColumn(name = "custom")
public class CustomTask extends Task {
}
