package kyu.back.domain.Factor;

import lombok.Getter;

import javax.persistence.DiscriminatorColumn;
import javax.persistence.Entity;

@Entity
@Getter
@DiscriminatorColumn(name = "standard")
public class StandardFactor extends Factor{
    private String stdCode;
}
