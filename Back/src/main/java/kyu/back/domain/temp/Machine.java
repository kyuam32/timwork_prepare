package kyu.back.domain.temp;

import lombok.Getter;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Getter
public class Machine {
    @Id
    @GeneratedValue
    @Column(name = "machine_id", nullable = false)
    private Long machine_id;

    private String name;

}
