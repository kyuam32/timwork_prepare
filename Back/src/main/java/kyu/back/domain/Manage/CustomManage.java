package kyu.back.domain.Manage;

import lombok.Getter;

import javax.persistence.DiscriminatorColumn;
import javax.persistence.Entity;

@Entity
@Getter
@DiscriminatorColumn(name = "custom")
public class CustomManage extends Manage{
}
