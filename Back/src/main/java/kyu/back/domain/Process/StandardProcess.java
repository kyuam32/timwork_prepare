package kyu.back.domain.Process;

import kyu.back.domain.Task.Task;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.DiscriminatorColumn;
import javax.persistence.Entity;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@DiscriminatorColumn(name = "standard")
public class StandardProcess extends Process {
    private String stdCode;

    public StandardProcess(Long id, String name, List<Task> task, String stdCode) {
        super(id, name, task);
        this.stdCode = stdCode;
    }
}
