package kyu.back.domain.Factor;

import lombok.Getter;

import javax.persistence.DiscriminatorColumn;
import javax.persistence.Entity;

@Entity
@Getter
@DiscriminatorColumn(name = "custom")
public class CustomFactor extends Factor{
}
